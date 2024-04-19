package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.SuccessMissionDto;
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

    @GetMapping("/api/{memberId}")
    public List<SuccessMissionDto> getSuccessMission(@PathVariable("memberId") Long memberId) {
        return successMissionService.showAll(memberId);
    }

    @PostMapping("/api/{memberId}/{missonId}")
    public ResponseEntity<SuccessMissionDto> save(@PathParam("memberId") Long memberId, @PathVariable("missonId") Long missionId, @RequestBody SuccessMissionDto successMissionDto) {
        SuccessMissionDto created = successMissionService.saveSuccessMission(memberId, missionId, successMissionDto);
        return (created != null) ?
                ResponseEntity.status(HttpStatus.CREATED).body(created) :
                ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
