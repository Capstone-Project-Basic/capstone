package capstone.socialchild.controller;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.SignIn;
import capstone.socialchild.dto.member.request.SignUp;
import capstone.socialchild.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
public class LoginController {

    private final MemberService memberService;
    private final SessionManager sessionManager;

    /**
     * 회원 가입
     */
    @PostMapping("login/new")
    public ResponseEntity<?> createMember(@RequestBody SignUp request) {

        Member member = Member.createMember(
                request.getLoginId(), request.getLoginPassword(),
                request.getName(), request.getBirth(), request.getGender(),
                request.getPhone_no(), request.getRole(),request.getStampCnt(),
                request.getLatitude(), request.getLongitude()
        );

        memberService.join(member);
        return ResponseEntity.status(HttpStatus.CREATED).body("회원 가입 성공");
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody SignIn request,
                                        BindingResult bindingResult, HttpServletResponse response) {

        if (bindingResult.hasErrors()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        Member loginMember = memberService.login(request.getLoginId(), request.getLoginPassword());

        if(loginMember == null) {
            bindingResult.reject("loginFail", "아이디 또는 비밀번호가 맞지 않습니다.");
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        // 로그인 성공 처리

        // 쿠키에 시간 정보X -> 브라우저 종료시 모두 종료
        sessionManager.createSession(loginMember, response);
        return ResponseEntity.ok("세션 로그인 성공!");
    }

    /**
     *  로그아웃
     */
    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpServletRequest request) {

        sessionManager.expire(request);
        return ResponseEntity.ok("로그아웃 성공!");
    }
}