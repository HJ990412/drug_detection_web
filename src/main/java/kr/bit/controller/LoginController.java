package kr.bit.controller;

import jakarta.servlet.http.HttpSession;
import kr.bit.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.bit.entity.Member;
import kr.bit.service.BoardService;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("login/*")
public class LoginController {

    @Autowired
    BoardMapper boardMapper;

    @Autowired
    BoardService boardService;

    @RequestMapping("/loginProcess")
    public String login(Member vo, HttpSession session) {
        Member mvo=boardService.login(vo);
        if(mvo!=null) {
            session.setAttribute("mvo", mvo); // 객체바인딩
        }

        return "redirect:/board/list";
    }

    @RequestMapping("/join")
    public String join(){
        return "board/join";
    }

    @RequestMapping("/memRegisterCheck")
    public @ResponseBody int memRegisterCheck(@RequestParam("memID") String memID) {

        Member m=boardService.registerCheck(memID);
        if(m!=null || memID.equals("")) {
            return 0;
        }

        return 1;
    }

    @RequestMapping("/memRegister")
    public String memRegister(Member m, String memPwd1, String memPwd2, RedirectAttributes rttr, HttpSession session) {
        if(m.getMemID()==null || m.getMemID().equals("") ||
                memPwd1==null || memPwd1.equals("") ||
                memPwd2==null || memPwd2.equals("") ||
                m.getMemName()==null || m.getMemName().equals("")
        ) {
            // 누락메시지를 가지고 가기? => 객체바인딩(Model, HttpServletRequest, HttpSession
            rttr.addFlashAttribute("msgType", "실패 메시지");
            rttr.addFlashAttribute("msg", "모든 내용을 입력하시오.");
            return "redirect:/login/join";
        }
        if(!memPwd1.equals(memPwd2)) {
            rttr.addFlashAttribute("msgType", "실패 메시지");
            rttr.addFlashAttribute("msg", "비밀번호가 일치하지 않음.");
            return "redirect:/login/join";
        }

        int result=boardService.memRegister(m);
        if(result==1) {
            rttr.addFlashAttribute("msgType", "성공 메시지");
            rttr.addFlashAttribute("msg", "회원가입 성공!");

            return "redirect:/board/list";
        }else {
            rttr.addFlashAttribute("msgType", "실패 메시지");
            rttr.addFlashAttribute("msg", "이미 존재하는 회원입니다.");
            return "redirect:/login/join";
        }
    }

    @RequestMapping("/logoutProcess")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/board/list";
    }

}
