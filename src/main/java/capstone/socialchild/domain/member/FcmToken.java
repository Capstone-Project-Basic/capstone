package capstone.socialchild.domain.member;

import capstone.socialchild.domain.mission.Mission;
import jakarta.persistence.*;
import lombok.*;

@Entity(name="Fcm_Token")
@Getter
@NoArgsConstructor
@ToString
@IdClass(FcmTokenId.class)
public class FcmToken {

    @Id
    @Column(name = "member_id")
    private Long memberId;

    @Id
    @Column
    private String token;

    @Column(name = "tokenFlag")
    private boolean tokenFlag;

    @ManyToOne
    @JoinColumn(name = "member_id", insertable = false, updatable = false)
    private Member member;

    @Builder
    public FcmToken(Long memberId, String token) {
        this.memberId = memberId;
        this.token = token;
        this.tokenFlag = false;
    }
}