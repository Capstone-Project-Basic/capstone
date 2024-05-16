package capstone.socialchild.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 세션 관리
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SessionManager {

    private static final String SESSION_COOKIE_NAME = "mySessionId";

    private Map<String, Object> sessionStore = new ConcurrentHashMap<>(); // <세션값, 멤버객체>

    /**
     * 세션 생성
     */
    public void createSession(Object value, HttpServletResponse response) {
        // 세션 id를 생성하고, 값을 세션에 저장
        String sessionId = UUID.randomUUID().toString();
        sessionStore.put(sessionId, value);
        log.info("세션 생성: sessionId={}, value={}", sessionId, value);

        // 쿠키 생성
        Cookie idCookie = new Cookie(SESSION_COOKIE_NAME, sessionId);
        response.addCookie(idCookie);
        log.info("쿠키 생성 및 응답에 추가: sessionId={}", sessionId);
    }


    /**
     * 세션 조회
     */
    public Object getSession(HttpServletRequest request) {

        Cookie sessionCookie = findCookie(request, SESSION_COOKIE_NAME);
        if (sessionCookie == null) {
            log.warn("세션 쿠키가 존재하지 않습니다.");
            return null;
        }
        Object session = sessionStore.get(sessionCookie.getValue());
        if (session == null) {
            log.warn("세션이 존재하지 않습니다: sessionId={}", sessionCookie.getValue());
        } else {
            log.info("세션 조회 성공: sessionId={}, value={}", sessionCookie.getValue(), session);
        }
        return session;
    }

    /**
     * 쿠키 조회
     */
    private Cookie findCookie(HttpServletRequest request, String cookieName) {

        if (request.getCookies() == null) {
            log.warn("쿠키가 존재하지 않습니다.");
            return null;
        }
        return Arrays.stream(request.getCookies())
                .filter(cookie -> cookie.getName().equals(cookieName))
                .findAny()
                .orElse(null);
    }

    /**
     * 세션 만료
     */
    public void expire(HttpServletRequest request) {

        Cookie sessionCookie = findCookie(request, SESSION_COOKIE_NAME);

        if (sessionCookie != null) {
            sessionStore.remove(sessionCookie.getValue());
            log.info("세션 만료: sessionId={}", sessionCookie.getValue());
        } else {
            log.warn("세션 만료 실패: 세션 쿠키가 존재하지 않습니다.");
        }
    }
}