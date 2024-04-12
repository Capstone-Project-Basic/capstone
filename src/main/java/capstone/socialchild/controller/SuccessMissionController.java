package capstone.socialchild.controller;

import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.dto.SuccessMissionDto;
import capstone.socialchild.dto.mission.SuccessMissionDto;
import capstone.socialchild.repository.SuccessMissionService;
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

    @PostMapping("/api/{memberId}")
    public ResponseEntity<SuccessMissionDto> save(@PathParam("memberId") Long memberId, @RequestBody SuccessMissionDto successMissionDto) {
        SuccessMissionDto created = successMissionService.saveSuccessMission(memberId, successMissionDto);
        return (created != null) ?
                ResponseEntity.status(HttpStatus.CREATED).body(created) :
                ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
