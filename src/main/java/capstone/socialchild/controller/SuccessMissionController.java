package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.SuccessMissionReqDto;
import capstone.socialchild.dto.mission.SuccessMissionResponseDto;
import capstone.socialchild.service.StampService;
import capstone.socialchild.service.SuccessMissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = {"https://localhost:8080"}) // Flutter 포트번호에 따라 바뀔 수 있음
@RequiredArgsConstructor
public class SuccessMissionController {

    @Autowired
    SuccessMissionService successMissionService;

    // 아이들이 본인 성공미션 목록 조회
    @GetMapping("/{memberId}/success-missions/")
    public List<SuccessMissionResponseDto> getSuccessMission(@PathVariable("memberId") Long memberId) {
        return successMissionService.showAllOneMember(memberId);
    }

    @GetMapping("/{memberId}/success-missions/{id}")
    public SuccessMissionResponseDto getSuccessMission(@PathVariable("memberId") Long memberId, @PathVariable("id") Long id) {
        return successMissionService.showOne(id);
    }

    // 선생님이 아이들 성공미션 목록 조회
    @GetMapping("/{memberId}/success-mission")
    public List<SuccessMissionResponseDto> getAllSuccessMissionsTEACHER() {
        return successMissionService.showAll();
    }

    // 성공미션 만들어주기 ( ONLY TEACHER )
    @PostMapping("/{memberId}/missions/{missionId}")
    public ResponseEntity<SuccessMissionResponseDto> save(@PathVariable("memberId") Long memberId, @PathVariable("missionId") Long missionId, @RequestBody SuccessMissionReqDto dto) {

        SuccessMissionResponseDto created = successMissionService.saveSuccessMission(memberId, missionId, dto);
        return (created != null) ?
                ResponseEntity.status(HttpStatus.CREATED).body(created) :
                ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
