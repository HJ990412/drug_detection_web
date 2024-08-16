package kr.bit.controller;

import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.fasterxml.jackson.databind.ObjectMapper;
import kr.bit.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import kr.bit.service.BoardService;

@Controller //POJO
@RequestMapping("board/*")
public class BoardController {

    @Value("${flask.server.url}")
    private String flaskServerUrl;

    @Autowired
    BoardService boardService;

    @RequestMapping("/list")
    public String getlist(Model model) {

        model.addAttribute("flaskServerUrl", flaskServerUrl);

        return "board/list"; //view

    }

    @GetMapping("/search")
    @ResponseBody
    private List<Food> getSearchList(@RequestParam("searchFood") String searchFood) {

        Food food = new Food();
        food.setSearchFood(searchFood);

        return boardService.getSearchList(food);
    }

    @GetMapping("/getMyDrug")
    public String get(@RequestParam("id") int id, Model model) {
        Image image = boardService.getMyDrug(id);
        String foodIngredients = boardService.getFoodIngredientsByDrugName(image.getMessage());
        model.addAttribute("foodIngredient", foodIngredients);
        model.addAttribute("image", image);

        return "board/mydrugResult";
    }

    @GetMapping("/drugSearchList")
    @ResponseBody
    public List<Image> drugSearchList(@RequestParam("memID") String memID) {

        return boardService.getImageByUserId(memID);
    }

    @GetMapping("/getFoodIngredients")
    @ResponseBody
    public Food getFoodIngredients(@RequestParam("foodName") String foodName){
        return boardService.getFoodIngredients(foodName);
    }

    @PostMapping("/uploadPhoto")
    @ResponseBody
    public Map<String, String> uploadPhoto(@RequestParam(value = "file", required = false) MultipartFile file,
                                           @RequestBody(required = false) Map<String, String> payload)
    {
        String userId = payload.get("user_id");
        String image = null;
        if (file != null) {
            try { 
                byte[] fileContent = file.getBytes();
                image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(fileContent);
            } catch (IOException e) {
                e.printStackTrace();
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("status", "error");
                errorResponse.put("message", "Failed to read the uploaded file");
                return errorResponse;
            }
        } else if (payload != null) {
            image = payload.get("image");
        }

        System.out.println("user_id in controller: " + userId);

        if (image == null) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "No image provided");
            return errorResponse;
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, String> request = new HashMap<>();
        request.put("image", image);
        request.put("user_id", userId);

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);
        ResponseEntity<String> flaskResponse = restTemplate.postForEntity(flaskServerUrl + "/upload_photo", entity, String.class);

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> responseMap = objectMapper.readValue(flaskResponse.getBody(), Map.class);

            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", (String) responseMap.get("message"));
            response.put("image_id", String.valueOf(responseMap.get("image_id")));

            return response;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", "Failed to parse Flask response");
            return errorResponse;
        }
    }

    @GetMapping("/drugResult")
    public String showDrugResult(@RequestParam("image_id") Long imageId, Model model) {
        Image image = boardService.getImageById(imageId);
        model.addAttribute("flaskMessage", image.getMessage());
        model.addAttribute("processedImage", image.getImage());
        String foodIngredients = boardService.getFoodIngredientsByDrugName(image.getMessage());
        model.addAttribute("foodIngredient", foodIngredients);
        return "board/drugResult";
    }
}
