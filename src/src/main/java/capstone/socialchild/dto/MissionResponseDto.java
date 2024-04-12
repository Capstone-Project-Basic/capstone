package capstone.socialchild.dto;

import capstone.socialchild.domain.Mission.Grade;
import capstone.socialchild.domain.Mission.Mission;

public class MissionResponseDto {
    private String title;
    private String content;
    private Grade grade;

    public MissionResponseDto(Mission mission) {
        this.title = mission.getTitle();
        this.content = mission.getContent();
        this.grade = mission.getGrade();
    }
}
