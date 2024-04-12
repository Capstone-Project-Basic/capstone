package capstone.socialchild.dto.mission;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SuccessMissionDto {

    private Long id;

    @JsonProperty("mission_id")
    private Long missionId;

    @JsonProperty("member_id")
    private Long memberId;

    @Builder
    public SuccessMissionDto(Long id, Long missionId, Long memberId) {
        this.id = id;
        this.missionId = missionId;
        this.memberId = memberId;
    }
}
