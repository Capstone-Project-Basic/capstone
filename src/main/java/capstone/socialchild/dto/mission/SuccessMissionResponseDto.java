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
public class SuccessMissionResponseDto {
    private Long id;

    @JsonProperty("mission_id")
    private Long missionId;

    @JsonProperty("member_id")
    private Long memberId;

    @Builder
    public SuccessMissionResponseDto(SuccessMission successMission) {
        this.id = successMission.getId();
        this.missionId = successMission.getMission().getMissionId();
        this.memberId = successMission.getMember().getId();
    }
//
//    @Builder
//    public SuccessMissionResponseDto(Long id, Long missionId, Long memberId) {
//        this.id = id;
//        this.missionId = missionId;
//        this.memberId = memberId;
//    }
}
