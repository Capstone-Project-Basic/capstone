package capstone.socialchild.dto.mission;

import capstone.socialchild.domain.mission.SuccessMission;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SuccessMissionResponseDto {
    private Long id;

    @JsonProperty("mission_id")
    private Long missionId;

    @JsonProperty("member_id")
    private Long memberId;

    public SuccessMissionResponseDto(SuccessMission successMission) {
        this.id = successMission.getId();
        this.missionId = successMission.getMission().getMissionId();
        this.memberId = successMission.getMember().getId();
    }
}
