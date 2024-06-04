package capstone.socialchild.service;

import capstone.socialchild.domain.member.FcmToken;
import capstone.socialchild.dto.fcm.FcmMessage;
import capstone.socialchild.dto.fcm.FcmRequestDto2;
import capstone.socialchild.repository.FcmTokenRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;


import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Slf4j
@Component
@Service
@RequiredArgsConstructor
public class FirebaseCloudMessageService {
    @Autowired
    private final ObjectMapper objectMapper;
    @Autowired
    private final FcmTokenRepository fcmTokenRepository;


    public void saveToken(FcmToken fcmToken) {
        fcmTokenRepository.save(fcmToken);
    }

    public void sendMessageTo(String targetToken, String title, String body) {
        try {
            String message = makeMessage(targetToken, title, body);
            sendMessage(message);
        } catch (JsonProcessingException e) {
            // JSON 처리 관련 예외 처리
            e.printStackTrace();
            // 로깅 추가
            System.err.println("Failed to create FCM message JSON: " + e.getMessage());
        } catch (IOException e) {
            // 네트워크 관련 예외 처리
            e.printStackTrace();
            // 로깅 추가
            System.err.println("Failed to send FCM message: " + e.getMessage());
        }
    }

    public void sendMessageToAllExcept(String exceptToken, String title, String body) throws IOException {
        List<String> tokens = fcmTokenRepository.findAllTokensExcept(exceptToken);
        for (String token : tokens) {
            String message = makeMessage(token, title, body);
            sendMessage(message);
        }
    }



    public void sendMessageToAllExceptTwo(String exceptToken1, String exceptToken2, String title, String body) throws IOException {
        List<String> tokens = fcmTokenRepository.findAllTokensExceptTwo(exceptToken1, exceptToken2);
        for (String token : tokens) {
            String message = makeMessage(token, title, body);
            sendMessage(message);
        }
    }


    private String makeMessage(String targetToken, String title, String body) throws JsonProcessingException {
        FcmMessage fcmMessage = FcmMessage.builder()
                .message(FcmMessage.Message.builder()
                        .token(targetToken)
                        .notification(FcmMessage.Notification.builder()
                                .title(title)
                                .body(body)
                                .build()
                        ).build())
                .validateOnly(false)
                .build();

        return objectMapper.writeValueAsString(fcmMessage);
    }

    private void sendMessage(String message) throws IOException {
        String API_URL = "https://fcm.googleapis.com/v1/projects/" +
                "pocket-teacher-1b526/messages:send";
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + getAccessToken());
        conn.setRequestProperty("Content-Type", "application/json; UTF-8");

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = message.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new IOException("Failed to send FCM message. Response code: " + responseCode);
        }
    }

    private String getAccessToken() throws IOException {
        String firebaseConfigPath = "firebase/firebase_service_key.json";

        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }
}
