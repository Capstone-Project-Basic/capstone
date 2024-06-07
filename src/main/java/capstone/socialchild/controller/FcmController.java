package capstone.socialchild.controller;

import capstone.socialchild.dto.fcm.Dto;
import capstone.socialchild.dto.fcm.FcmRequestDto;
import capstone.socialchild.dto.fcm.FcmRequestDto2;
import capstone.socialchild.dto.fcm.SendToOneDto;
import capstone.socialchild.repository.FcmTokenRepository;
import capstone.socialchild.repository.MemberRepository;
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
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/fcm")
@RequiredArgsConstructor
public class FcmController {

    private final FirebaseCloudMessageService firebaseCloudMessageService;
    @Autowired
    private FcmTokenRepository fcmTokenRepository;
    @Autowired
    private MemberRepository memberRepository;

    private static final Logger logger = LoggerFactory.getLogger(FcmController.class);

    //한명(토큰)에게 제목, 내용 정해서 보내기
    @PostMapping("/send")
    public ResponseEntity<String> pushMessage(@RequestBody FcmRequestDto requestDTO)  {
        firebaseCloudMessageService.sendMessageTo(requestDTO.getToken(), requestDTO.getTitle(), requestDTO.getBody());
        return ResponseEntity.ok().build();
    }

    //한명(토큰)에게 default 메세지 보내기
    @PostMapping("/sendToOne")
    public ResponseEntity<String> sendToTone(@RequestBody SendToOneDto sendToOneDto) {
        String targetToken= fcmTokenRepository.findTokenByMemberId(sendToOneDto.getTargetId());
        firebaseCloudMessageService.sendMessageTo(targetToken,
                "친구가 나를 불러요 !",
                memberRepository.findNameById(sendToOneDto.getSenderId()) +
                        " 친구가 " + sendToOneDto.getLocation()+ "에서 나를 불러요 !");
        return ResponseEntity.ok().build();
    }

    //한명(토큰) 제외 모든 유저에게 제목, 내용 정해서 보내기
    @PostMapping("/sendToAllExcept")
    public ResponseEntity<String> sendMessageToAllExcept(@RequestBody FcmRequestDto requestDto) {
        try {
            firebaseCloudMessageService.sendMessageToAllExcept(requestDto.getToken(), requestDto.getTitle(), requestDto.getBody());
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    //두명(토큰) 제외 모든 유저에게 제목, 내용 정해서 보내기
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

    //두명(토큰) 제외 모든 유저에게 default 메세지 보내기. But, 요청 모아서 보내는 로직
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
                requestDto2.setTitle("친구들이 만났어요 !");
                requestDto2.setBody(
                        memberRepository.findNameById(fcmTokenRepository.findIdByToken(yo.get(0)))
                                + " 친구와 " + memberRepository.findNameById(fcmTokenRepository.findIdByToken(yo.get(1)))
                                + " 친구가 하이파이브에 성공했어요 !"
                );
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