package capstone.socialchild.dto.fcm;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FcmRequestDto {
    private String token;
    private String title;
    private String body;
}
