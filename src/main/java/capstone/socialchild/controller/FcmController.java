package capstone.socialchild.controller;

import capstone.socialchild.dto.fcm.FcmRequestDto;
import capstone.socialchild.service.FirebaseCloudMessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RequestMapping("/api/fcm")
@RestController
@RequiredArgsConstructor
@Slf4j
public class FcmController {

    private final FirebaseCloudMessageService firebaseCloudMessageService;

    @PostMapping("/send")
    public ResponseEntity<String> pushMessage(@RequestBody FcmRequestDto requestDTO)  {
        firebaseCloudMessageService.sendMessageTo(requestDTO.getToken(), requestDTO.getTitle(), requestDTO.getBody());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/sendToAllExcept")
    public ResponseEntity<String> sendMessageToAllExcept(@RequestBody FcmRequestDto requestDto) {
        try {
            firebaseCloudMessageService.sendMessageToAllExcept(requestDto.getToken(), requestDto.getTitle(), requestDto.getBody());
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}