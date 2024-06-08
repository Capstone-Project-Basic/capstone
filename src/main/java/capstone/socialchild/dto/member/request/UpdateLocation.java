package capstone.socialchild.dto.member.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
public class UpdateLocation {

    private Double latitude;
    private Double longitude;
}