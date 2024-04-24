package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.SuccessMissionReqDto;
import capstone.socialchild.dto.mission.SuccessMissionResponseDto;
import capstone.socialchild.service.SuccessMissionService;
import jakarta.websocket.server.PathParam;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/success-missions")
@CrossOrigin(origins = {"https://localhost:8080"}) // Flutter 포트번호에 따라 바뀔 수 있음
@RequiredArgsConstructor
public class SuccessMissionController {

    @Autowired
    SuccessMissionService successMissionService;

    @GetMapping("/{memberId}")
    public List<SuccessMissionResponseDto> getSuccessMission(@PathVariable("memberId") Long memberId) {
        return successMissionService.showAll(memberId);
    }

    @GetMapping("/{memberId}/{id}")
    public SuccessMissionResponseDto getSuccessMission(@PathVariable("memberId") Long memberId, @PathVariable("id") Long id) {
        return successMissionService.showOne(id);
    }

    @PostMapping("/{memberId}")
    public ResponseEntity<SuccessMissionResponseDto> save(@PathVariable("memberId") Long memberId, @RequestBody SuccessMissionReqDto successMissionDto) {
        SuccessMissionResponseDto created = successMissionService.saveSuccessMission(memberId, successMissionDto);
        return (created != null) ?
                ResponseEntity.status(HttpStatus.CREATED).body(created) :
                ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
