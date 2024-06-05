package capstone.socialchild.dto.mission;

import capstone.socialchild.domain.mission.Grade;
import capstone.socialchild.domain.mission.Mission;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Optional;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class MissionListResponseDto {
    private Long missionId;
    private String title;
    private String content;
    private Grade grade;
    private Boolean activeStatus;

    //Entity -> Dto
    public MissionListResponseDto(Mission mission) {
        this.missionId = mission.getMissionId();
        this.title = mission.getTitle();
        this.content = mission.getContent();
        this.grade = mission.getGrade();
        this.activeStatus = mission.getActiveStatus();
    }
    public MissionListResponseDto(Optional<Mission> mission) {
        this.missionId = mission.get().getMissionId();
        this.title = mission.get().getTitle();
        this.content = mission.get().getContent();
        this.grade = mission.get().getGrade();
        this.activeStatus = mission.get().getActiveStatus();
    }
}
