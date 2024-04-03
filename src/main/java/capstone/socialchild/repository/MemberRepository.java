package capstone.socialchild.repository;

import capstone.socialchild.domain.member.Member;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MemberRepository {

    @PersistenceContext
    private final EntityManager em;

    public String save(Member member) {
        em.persist(member);
        return member.getUserid();
    }

    public Member findOne(String userid) {
        return em.find(Member.class, userid);
    }

    public List<Member> findAll() {
        return em.createQuery("select m from Member m", Member.class)
                .getResultList();
    }

    public List<Member> findById(String userid) {
        return em.createQuery("select m from Member m where m.userid = :userid", Member.class)
                .setParameter("userid", userid)
                .getResultList();
    }

    public List<Member> findByName(String name) {
        return em.createQuery("select m from Member m where m.name = :name", Member.class)
                .setParameter("name", name)
                .getResultList();
    }
}
