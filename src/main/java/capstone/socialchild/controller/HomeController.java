package capstone.socialchild.controller;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.repository.MemberRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {

    private final MemberRepository memberRepository;
    private final SessionManager sessionManager;

    //@RequestMapping("/")
    public void home() {
        log.info("home controller");
    }

    @GetMapping("/")
    public ResponseEntity<Object> homeLogin(HttpServletRequest request) {

        // 세션 관리자에 저장된 회원 정보 조회
        Member member = (Member)sessionManager.getSession(request);

        if (member == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("No memberId provided");
        }

        return ResponseEntity.ok(member);
    }
}