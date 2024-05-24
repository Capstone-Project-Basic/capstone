package capstone.socialchild.dto.mission;


import capstone.socialchild.domain.mission.Grade;
import capstone.socialchild.domain.mission.Mission;
import lombok.Getter;

@Getter
public class MissionResponseDto {
    private String title;
    private String content;
    private Grade grade;
    private Boolean activeStatus;

    public MissionResponseDto(Mission mission) {
        this.title = mission.getTitle();
        this.content = mission.getContent();
        this.grade = mission.getGrade();
        this.activeStatus = mission.getActiveStatus();
    }
}
