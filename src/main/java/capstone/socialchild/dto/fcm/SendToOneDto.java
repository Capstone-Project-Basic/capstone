package capstone.socialchild.dto.fcm;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class SendToOneDto {
    private Long memberId;
    private String location;
}
