package capstone.socialchild.domain.mission;


import capstone.socialchild.domain.member.Member;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class SuccessMission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "mission_id")
    private Mission mission;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @Builder
    public SuccessMission(Mission mission, Member member) {
        this.mission = mission;
        this.member = member;
    }

}
