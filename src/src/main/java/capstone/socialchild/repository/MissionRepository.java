package capstone.socialchild.repository;

import capstone.socialchild.domain.Mission.Mission;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MissionRepository extends JpaRepository<Mission, Long> {
}
