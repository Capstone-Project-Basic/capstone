package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.SuccessMissionDto;
import capstone.socialchild.dto.mission.SuccessMissionResponseDto;
import capstone.socialchild.service.SuccessMissionService;
import jakarta.websocket.server.PathParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class SuccessMissionController {

    @Autowired
    SuccessMissionService successMissionService;

    @GetMapping("/{memberId}/success-missions")
    public List<SuccessMissionDto> getSuccessMission(@PathVariable("memberId") Long memberId) {
        return successMissionService.showAll(memberId);
    }

    @GetMapping("/{memberId}/success-missions/{id}")
    public SuccessMissionResponseDto getSuccessMission(@PathVariable("memberId") Long memberId, @PathVariable("id") Long id) {
        return successMissionService.showOne(id);
    }

    @PostMapping("/{memberId}/success-missions")
    public ResponseEntity<SuccessMissionDto> save(@PathParam("memberId") Long memberId, @RequestBody SuccessMissionDto successMissionDto) {
        SuccessMissionDto created = successMissionService.saveSuccessMission(memberId, successMissionDto.getMissionId(), successMissionDto);
        return (created != null) ?
                ResponseEntity.status(HttpStatus.CREATED).body(created) :
                ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
