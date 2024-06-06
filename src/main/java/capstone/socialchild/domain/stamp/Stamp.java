package capstone.socialchild.domain.stamp;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.domain.mission.SuccessMission;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
public class Stamp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JsonProperty("member_id")
    private Member member;

    @OneToOne(optional = true)
    @JsonProperty("success_mission_id")
    private SuccessMission successMission;

    @Builder
    public Stamp(Member member, SuccessMission successMission) {
        this.member = member;
        this.successMission = successMission;
    }
}
