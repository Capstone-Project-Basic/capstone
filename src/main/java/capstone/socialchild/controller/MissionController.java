package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.MissionListResponseDto;
import capstone.socialchild.dto.mission.MissionRequestDto;
import capstone.socialchild.dto.mission.MissionResponseDto;
import capstone.socialchild.service.MissionService;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
@CrossOrigin(origins = {"https://localhost:8080"}) // Flutter 포트번호에 따라 바뀔 수 있음
@RequestMapping("/missions")
public class MissionController {

    @Autowired
    private MissionService missionService;

    @GetMapping("/{missionId}")
    public MissionResponseDto getMission(@PathVariable Long missionId) {
        return missionService.findOneMission(missionId);
    }

    @GetMapping
    public List<MissionListResponseDto> getAllMission() {
        return missionService.findAllMission();
    }

    @PostMapping
    public MissionResponseDto addMission(@RequestBody MissionRequestDto missionRequestDto) {
        return missionService.createMission(missionRequestDto);
    }

    @PatchMapping("/{missionId}")
    public Long updateMission(@PathVariable Long missionId, @RequestBody MissionRequestDto missionRequestDto) {
        return missionService.update(missionId, missionRequestDto);
    }

    @DeleteMapping("/{missionId}")
    public Long deleteMission(@PathVariable("missionId") Long missionId) {
        return missionService.delete(missionId);
    }
}
