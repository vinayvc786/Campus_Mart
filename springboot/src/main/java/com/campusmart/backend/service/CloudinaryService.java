package com.campusmart.backend.service;

import com.campusmart.backend.exception.BadRequestException;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Base64;
import java.util.Map;

@Service
public class CloudinaryService {

    private static final Logger log = LoggerFactory.getLogger(CloudinaryService.class);

    private final Cloudinary cloudinary;

    public CloudinaryService(@Autowired(required = false) Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }

    public String uploadImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BadRequestException("Uploaded file is empty");
        }

        // Validate content type
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new BadRequestException("Only image files are supported (JPEG, PNG, WEBP, etc.)");
        }

        if (cloudinary != null) {
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> uploadResult = cloudinary.uploader().upload(
                        file.getBytes(),
                        ObjectUtils.asMap(
                                "folder", "campus_mart_products",
                                "resource_type", "image"
                        )
                );
                String secureUrl = (String) uploadResult.get("secure_url");
                log.info("Image uploaded successfully to Cloudinary: {}", secureUrl);
                return secureUrl;
            } catch (IOException e) {
                log.error("Cloudinary upload failed: {}", e.getMessage(), e);
                throw new BadRequestException("Failed to upload image to Cloudinary: " + e.getMessage());
            }
        } else {
            // Local fallback when Cloudinary credentials are not configured
            log.warn("Cloudinary credentials not set in environment. Falling back to data URI encoding.");
            try {
                byte[] bytes = file.getBytes();
                String base64 = Base64.getEncoder().encodeToString(bytes);
                return "data:" + contentType + ";base64," + base64;
            } catch (IOException e) {
                throw new BadRequestException("Failed to process image file: " + e.getMessage());
            }
        }
    }
}
