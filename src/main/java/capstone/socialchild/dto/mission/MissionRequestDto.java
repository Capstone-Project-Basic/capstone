package capstone.socialchild.dto.mission;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.domain.mission.Grade;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class MissionRequestDto {
    private String title;
    private String content;
    private Grade grade;
    private Role role; // 계급 판단 위해

    public MissionRequestDto(String title, String content, Grade grade, Role role) {
        this.title = title;
        this.content = content;
        this.grade = grade;
        this.role = role;
    }
}
