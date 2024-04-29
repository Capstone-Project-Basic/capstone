package capstone.socialchild.dto.mission;

import capstone.socialchild.domain.mission.SuccessMission;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class SuccessMissionReqDto {


    private Long missionId;
    private Long memberId;

}
