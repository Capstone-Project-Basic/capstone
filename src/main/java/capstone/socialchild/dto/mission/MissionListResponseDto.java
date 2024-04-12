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
    private String title;
    private String content;
    private Grade grade;

    //Entity -> Dto
    public MissionListResponseDto(Mission mission) {
        this.title = mission.getTitle();
        this.content = mission.getContent();
        this.grade = mission.getGrade();
    }
    public MissionListResponseDto(Optional<Mission> mission) {
        this.title = mission.get().getTitle();
        this.content = mission.get().getContent();
        this.grade = mission.get().getGrade();
    }
}
