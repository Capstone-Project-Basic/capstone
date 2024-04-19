package capstone.socialchild.dto.stamp;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class StampRequestDto {
    private Long id;
    private Long memberId;
    private Long successMissionId;

    @Builder
    public StampRequestDto(Long id, Long memberId, Long successMissionId) {
        this.id = id;
        this.memberId = memberId;
        this.successMissionId = successMissionId;
    }


}
