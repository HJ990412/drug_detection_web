package kr.bit.controller;

import kr.bit.entity.Member;
import kr.bit.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class MemberController {

    @Autowired
    BoardService boardService;

    @RequestMapping ("/members")
    public String listMembers(Model model) {
        List<Member> members = boardService.getAllMembers();
        model.addAttribute("members", members);
        return "admin/memberList";
    }

    @PostMapping("/deleteMember")
    public String deleteMember(@RequestParam("memID") String memID, RedirectAttributes rttr) {

        try {
            boardService.deleteMember(memID);
            rttr.addFlashAttribute("msg", "회원 삭제 성공");
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "회원 삭제 실패");
        }

        return "redirect:/admin/members";
    }


}
