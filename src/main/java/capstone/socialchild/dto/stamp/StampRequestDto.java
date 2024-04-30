package capstone.socialchild.dto.stamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class StampRequestDto {
    private Long memberId;
    private Long successMissionId;

//    @Builder
//    public StampRequestDto(Long id, Long memberId, Long successMissionId) {
//        this.memberId = memberId;
//        this.successMissionId = successMissionId;
//    }


}
