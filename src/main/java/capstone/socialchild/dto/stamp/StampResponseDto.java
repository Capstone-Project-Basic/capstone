package capstone.socialchild.dto.stamp;

import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.domain.stamp.Stamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class StampResponseDto {
    private Long id;

    private Long memberId;

    private Long successMissionId;

    @Builder
    public StampResponseDto(Stamp stamp) {
        this.id = stamp.getId();
        this.memberId = stamp.getMember().getId();
        this.successMissionId = stamp.getSuccessMission().getId();
    }

}
