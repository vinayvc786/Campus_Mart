package com.campusmart.backend.repository;

import com.campusmart.backend.model.Listing;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Repository
public class ListingRepositoryCustomImpl implements ListingRepositoryCustom {

    private final MongoTemplate mongoTemplate;

    public ListingRepositoryCustomImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public List<Listing> findWithFilters(
            String search,
            String category,
            String department,
            String semester,
            String condition,
            Integer minPrice,
            Integer maxPrice,
            String sellerId,
            Boolean isSold,
            String sortBy
    ) {
        Query query = new Query();
        List<Criteria> criteriaList = new ArrayList<>();

        // Search across title, description, category, department
        if (StringUtils.hasText(search)) {
            Pattern searchPattern = Pattern.compile(Pattern.quote(search.trim()), Pattern.CASE_INSENSITIVE);
            criteriaList.add(new Criteria().orOperator(
                    Criteria.where("title").regex(searchPattern),
                    Criteria.where("description").regex(searchPattern),
                    Criteria.where("category").regex(searchPattern),
                    Criteria.where("department").regex(searchPattern),
                    Criteria.where("subjectCode").regex(searchPattern)
            ));
        }

        // Category filter
        if (StringUtils.hasText(category) && !"All".equalsIgnoreCase(category.trim())) {
            criteriaList.add(Criteria.where("category").is(category.trim()));
        }

        // Department filter (support short codes like cs, mech, civil, ee)
        if (StringUtils.hasText(department) && !"all".equalsIgnoreCase(department.trim())) {
            String depTrim = department.trim().toLowerCase();
            String regex;
            switch (depTrim) {
                case "cs":
                case "comp sci":
                    regex = "(cs|comp|computer)";
                    break;
                case "mech":
                    regex = "mech";
                    break;
                case "civil":
                    regex = "civil";
                    break;
                case "ee":
                    regex = "(ee|elec|electrical)";
                    break;
                default:
                    regex = Pattern.quote(depTrim);
            }
            criteriaList.add(Criteria.where("department").regex(regex, "i"));
        }

        // Semester filter
        if (StringUtils.hasText(semester)) {
            criteriaList.add(Criteria.where("semester").regex(Pattern.quote(semester.trim()), "i"));
        }

        // Condition filter
        if (StringUtils.hasText(condition)) {
            criteriaList.add(Criteria.where("condition").regex(Pattern.quote(condition.trim()), "i"));
        }

        // Price range
        if (minPrice != null && minPrice > 0) {
            criteriaList.add(Criteria.where("price").gte(minPrice));
        }
        if (maxPrice != null && maxPrice > 0) {
            criteriaList.add(Criteria.where("price").lte(maxPrice));
        }

        // Seller ID filter (e.g., viewing own products)
        if (StringUtils.hasText(sellerId)) {
            criteriaList.add(Criteria.where("sellerId").is(sellerId.trim()));
        }

        // Sold status
        if (isSold != null) {
            criteriaList.add(Criteria.where("isSold").is(isSold));
        }

        if (!criteriaList.isEmpty()) {
            query.addCriteria(new Criteria().andOperator(criteriaList.toArray(new Criteria[0])));
        }

        // Sorting
        if ("low-to-high".equalsIgnoreCase(sortBy)) {
            query.with(Sort.by(Sort.Direction.ASC, "price"));
        } else if ("high-to-low".equalsIgnoreCase(sortBy)) {
            query.with(Sort.by(Sort.Direction.DESC, "price"));
        } else if ("newest".equalsIgnoreCase(sortBy)) {
            query.with(Sort.by(Sort.Direction.DESC, "createdAt"));
        } else {
            // Default "recommended": featured first, then newest
            query.with(Sort.by(Sort.Direction.DESC, "isFeatured", "createdAt"));
        }

        return mongoTemplate.find(query, Listing.class);
    }
}
