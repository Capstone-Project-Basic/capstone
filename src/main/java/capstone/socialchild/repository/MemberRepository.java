package capstone.socialchild.repository;
import capstone.socialchild.domain.member.Member;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MemberRepository {

    @PersistenceContext
    private final EntityManager em;

    @Transactional
    public Long save(Member member) {
        em.persist(member);
        return member.getId();
    }

    @Transactional
    public void update(Member member) {
        Long id = member.getId();
        Long stampCnt = member.getStampCnt();

        if (id == null) {
            throw new IllegalArgumentException("Member ID must not be null for update.");
        }

        Query query = em.createQuery("UPDATE Member m SET m.StampCnt = :stampCnt WHERE m.id = :id");
        query.setParameter("stampCnt", stampCnt);
        query.setParameter("id", id);

        int updatedCount = query.executeUpdate();
        if (updatedCount == 0) {
            throw new IllegalArgumentException("No Member entity with the given ID was found for update.");
        }
    }

    public Member findOne(Long id) {
        return em.find(Member.class, id);
    }

    public List<Member> findAll() {
        return em.createQuery("select m from Member m", Member.class)
                .getResultList();
    }

    public String findNameById(Long memberId) {
        return em.createQuery("select m.name from Member m where m.id = :memberId", String.class)
                .setParameter("memberId", memberId)
                .getSingleResult();
    }

    public Optional<Member> findById(Long id) {
        try {
            Member member = em.createQuery("select m from Member m where m.id = :id", Member.class)
                    .setParameter("id", id)
                    .getSingleResult();
            return Optional.ofNullable(member);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<Member> findByLoginId(String loginId) {
        return em.createQuery("select m from Member m where m.loginId = :loginId", Member.class)
                .setParameter("loginId", loginId)
                .getResultList();
    }

    public Optional<Member> findOneByLoginId(String loginId) {
        return findAll().stream()
                .filter(m -> m.getLoginId().equals(loginId))
                .findFirst();
    }


    public List<Member> findByName(String name) {
        return em.createQuery("select m from Member m where m.name = :name", Member.class)
                .setParameter("name", name)
                .getResultList();
    }

    public void delete(Long id) {
        em.remove(findOne(id));
    }
}
