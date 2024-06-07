package capstone.socialchild.dto.fcm;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class SendToOneDto {
    private Long senderId;
    private Long targetId;
    private String location;
}
