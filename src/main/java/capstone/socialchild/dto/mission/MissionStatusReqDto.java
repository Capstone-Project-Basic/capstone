package capstone.socialchild.dto.mission;

import capstone.socialchild.domain.member.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MissionStatusReqDto {
    private Boolean activeStatus;
    private Role role; // 세션 구현되면 Member로 변경

    public MissionStatusReqDto(Boolean activeStatus, Role role) {
        this.activeStatus = activeStatus;
        this.role = role;
    }
}
