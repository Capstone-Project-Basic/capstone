package capstone.socialchild.domain.member;

import capstone.socialchild.domain.mission.Mission;
import jakarta.persistence.*;
import lombok.*;

@Entity(name="Fcm_Token")
@Getter
@NoArgsConstructor
@ToString
public class FcmToken {
    @Id
    private Long id;

    @Column
    private String token;

}
