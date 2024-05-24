package capstone.socialchild.repository;

import capstone.socialchild.domain.mission.Mission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MissionRepository extends JpaRepository<Mission, Long> {
    public List<Mission> findByTitle(String title);
}
