package capstone.socialchild.controller;

import capstone.socialchild.dto.MissionListResponseDto;
import capstone.socialchild.dto.MissionRequestDto;
import capstone.socialchild.dto.MissionResponseDto;
import capstone.socialchild.service.MissionService;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
public class MissionController {

    @Autowired
    private MissionService missionService;

    @GetMapping("/missions/{missionId}")
    public MissionResponseDto getMission(@PathVariable Long missionId) {
        return missionService.findOneMission(missionId);
    }

    @GetMapping("/missions")
    public List<MissionListResponseDto> getAllMission() {
        return missionService.findAllMission();
    }

    @PostMapping("/missions")
    public MissionResponseDto addMission(@RequestBody MissionRequestDto missionRequestDto) {
        return missionService.createMission(missionRequestDto);
    }

    @PutMapping("/missions/{missionId}")
    public Long updateMission(@PathVariable Long missionId, @RequestBody MissionRequestDto missionRequestDto) {
        return missionService.update(missionId, missionRequestDto);
    }

    @DeleteMapping("/mission/{missionId}")
    public Long deleteMission(@PathVariable Long missionId) {
        return missionService.delete(missionId);
    }
}
