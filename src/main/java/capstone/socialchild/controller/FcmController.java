package capstone.socialchild.controller;


import capstone.socialchild.domain.member.FcmToken;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.dto.fcm.Dto;
import capstone.socialchild.dto.fcm.FcmRequestDto;
import capstone.socialchild.dto.fcm.FcmRequestDto2;
import capstone.socialchild.dto.mission.MissionListResponseDto;
import capstone.socialchild.repository.FcmTokenRepository;
import capstone.socialchild.service.FirebaseCloudMessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RequestMapping("/api/fcm")
@RestController
@RequiredArgsConstructor
@Slf4j
public class FcmController {

    private final FirebaseCloudMessageService firebaseCloudMessageService;
    @Autowired
    private FcmTokenRepository fcmTokenRepository;

    private static final Logger logger = LoggerFactory.getLogger(FcmController.class);

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

    @PostMapping("/sendToAllExceptTwo")
    public ResponseEntity<String> sendMessageToAllExceptTwo(@RequestBody FcmRequestDto2 requestDto2) {
        try {
            firebaseCloudMessageService.sendMessageToAllExceptTwo(
                    requestDto2.getToken1(), requestDto2.getToken2()
                    , requestDto2.getTitle(), requestDto2.getBody());
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/sendToAllExceptTwo2")
    public ResponseEntity<String> sendMessageToAllExceptTwo(@RequestBody Dto dto) {
        try {
            String setTrueToken = dto.getToken();
            fcmTokenRepository.setTokenTrue(setTrueToken);
            if(fcmTokenRepository.countFlag()==2){
                FcmRequestDto2 requestDto2 = new FcmRequestDto2();
                List<String> yo = fcmTokenRepository.flagTrue();
                requestDto2.setToken1(yo.get(0));
                requestDto2.setToken2(yo.get(1));
                requestDto2.setTitle("ㅎㅇ");
                requestDto2.setBody("뭐요");
                firebaseCloudMessageService.sendMessageToAllExceptTwo(
                        requestDto2.getToken1(), requestDto2.getToken2()
                        , requestDto2.getTitle(), requestDto2.getBody());
                fcmTokenRepository.initFlag();
            }
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}