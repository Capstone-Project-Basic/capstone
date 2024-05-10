package capstone.socialchild.controller;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.SignIn;
import capstone.socialchild.dto.member.request.SignUp;
import capstone.socialchild.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@Slf4j
@RequestMapping("/login")
@RequiredArgsConstructor
@CrossOrigin(origins = {"https://localhost:8080"})
public class LoginController {

    private final MemberService memberService;
    private final SessionManager sessionManager;

    /**
     * 회원 가입
     */
    @PostMapping("/new")
    public ResponseEntity<Member> createMember(@RequestBody SignUp request) {

        Member member = Member.createMember(request.getLoginId(), request.getLoginPassword(), request.getName(), request.getBirth(), request.getGender(), request.getPhone_no(), request.getRole());
        Long memberId = memberService.join(member);

        return ResponseEntity
                .created(URI.create("/new/" + memberId))
                .build();
    }

    /**
     * 회원 로그인
     */
    @PostMapping
    public ResponseEntity<String> login(@RequestBody SignIn request, HttpServletResponse response) {

        boolean isAuthenticated = memberService.authenticate(request.getLoginId(), request.getLoginPassword());

        if (isAuthenticated) {
            // 로그인 성공 시 세션 생성
            sessionManager.createSession(request.getLoginId(), response);
            return ResponseEntity.ok("로그인 성공!");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 실패. 아이디 또는 비밀번호를 확인해주세요.");
        }
    }

    /**
     *  회원 로그아웃
     */
    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpServletRequest request) {
        sessionManager.expire(request);
        return ResponseEntity.ok("로그아웃 성공!");
    }
}