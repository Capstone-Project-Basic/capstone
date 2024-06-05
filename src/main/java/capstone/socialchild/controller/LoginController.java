package capstone.socialchild.controller;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.FcmToken;
import capstone.socialchild.dto.member.request.SignIn;
import capstone.socialchild.dto.member.request.SignUp;
import capstone.socialchild.service.FirebaseCloudMessageService;
import capstone.socialchild.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class LoginController {

    private final MemberService memberService;
    private final SessionManager sessionManager;
    private final FirebaseCloudMessageService firebaseCloudMessageService;
    /**
     * 회원 가입
     */
    @PostMapping("login/new")
    public ResponseEntity<?> createMember(@RequestBody SignUp request) {

        Member member = Member.createMember(
                request.getLoginId(), request.getLoginPassword(),
                request.getName(), request.getBirth(), request.getGender(),
                request.getPhone_no(), request.getRole()
        );

//        Long memberId = memberService.join(member);
//
//        return ResponseEntity
//                .created(URI.create("/new/" + memberId))
//                .build();

        //회원가입 시 기기 토큰값도 같이 받아와서 Fcm_token 테이블에 저장
        Long memberIdForToken = memberService.join(member);
        FcmToken fcmToken = new FcmToken(memberIdForToken,request.getToken());
        firebaseCloudMessageService.saveToken(fcmToken);

        return ResponseEntity.status(HttpStatus.CREATED).body("회원 가입 성공");
    }

    @GetMapping("/login")
    public ResponseEntity<?> login(@RequestBody SignIn signIn) {
        Member member = memberService.login(signIn.getLoginId(), signIn.getLoginPassword());
        return ResponseEntity.ok(member);
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

//    private void expireCookie(HttpServletResponse response, String cookieName) {
//        Cookie cookie = new Cookie(cookieName, null);
//        cookie.setMaxAge(0);
//        response.addCookie(cookie);
//    }
//    /**
//     * 세션 정보 보기
//     */
//    @GetMapping("/session-info")
//    public ResponseEntity<String> sessionInfo(HttpServletRequest request) {
//        Object sessionValue = sessionManager.getSession(request);
//
//        if (sessionValue == null) {
//            return ResponseEntity.ok("세션이 없습니다.");
//        }
//
//        // 세션 정보 출력
//        log.info("Session Value={}", sessionValue);
//
//        return ResponseEntity.ok("세션 정보: " + sessionValue.toString());
//    }
}