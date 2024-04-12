package capstone.socialchild.dto;

import capstone.socialchild.domain.Mission.Grade;
import capstone.socialchild.domain.member.Member;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class MissionRequestDto {
    private String title;
    private String content;
    private Grade grade;
    private Member member; // 계급 판단 위해

    public MissionRequestDto(String title, String content, Grade grade, Member member) {
        this.title = title;
        this.content = content;
        this.grade = grade;
        this.member = member;
    }
}
