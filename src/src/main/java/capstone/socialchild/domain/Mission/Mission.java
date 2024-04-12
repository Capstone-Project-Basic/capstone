package capstone.socialchild.domain.Mission;

import capstone.socialchild.dto.MissionRequestDto;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import static jakarta.persistence.EnumType.STRING;

@Setter
@Getter
@NoArgsConstructor
@Entity(name = "mission")
public class Mission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mission_id")
    private Long missionId;

    @Column
    private String title;

    @Column
    private String content;

    @Enumerated(value = STRING)
    private Grade grade;

    //requestDto 정보를 가져와 entity 만들 때 사용
    public Mission (MissionRequestDto requestDto) {
        this.title = requestDto.getTitle();
        this.content = requestDto.getContent();
        this.grade = requestDto.getGrade();
    }

    //업데이트 메소드
    public void update(MissionRequestDto requestDto) {
        this.title = requestDto.getTitle();
        this.content = requestDto.getContent();
        this.grade = requestDto.getGrade();
    }
}
