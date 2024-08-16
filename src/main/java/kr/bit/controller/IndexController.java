package kr.bit.controller;

import kr.bit.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

    @Autowired
    BoardService boardService;

    @RequestMapping("/")
    public String Index(){

        return "login/login";

    }
}
