package capstone.socialchild.config;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Role;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import java.time.LocalDate;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class SessionManagerTest {

    SessionManager sessionManager = new SessionManager();

    @Test
    void sessionTest() {
        // 세션 생성 및 Http 응답을 받고 세션을 쿠키에 담고, response에 쿠키가 담김
        MockHttpServletResponse response = new MockHttpServletResponse();
        Member member = Member.createMember(
                "testUser", "testPass", "Test User", LocalDate.now(), Gender.MALE, "123-456-7890", Role.CHILD);
        sessionManager.createSession(member, response);

        // 요청에 응답 쿠키 저장
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setCookies(response.getCookies());

        // 세션 조회, 클라이언트에서 다시 서버로 요청함
        Object result = sessionManager.getSession(request);
        assertThat(result).isEqualTo(member);
        // 객체 비교

        // 세션 만료
        sessionManager.expire(request);
        Object expired = sessionManager.getSession(request);
        assertThat(expired).isNull();  // 만료된 세션 확인
    }
}
