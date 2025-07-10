package com.boot.z_config.gemini.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
public class GeminiServiceImpl implements GeminiService {
	@Value("${apiKey}")
	private String apiKey;

	private final HttpClient httpClient = HttpClient.newHttpClient();

	public String extractReplyText(String responseBody) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(responseBody);

		JsonNode candidatesNode = root.path("candidates");
		if (candidatesNode.isMissingNode() || candidatesNode.isEmpty()) {
			throw new IllegalStateException("응답에 candidates가 없습니다: " + responseBody);
		}

		JsonNode firstCandidate = candidatesNode.get(0);
		if (firstCandidate == null) {
			throw new IllegalStateException("candidates 배열이 비어있습니다");
		}

		JsonNode contentNode = firstCandidate.path("content");
		JsonNode partsNode = contentNode.path("parts");
		if (partsNode.isEmpty()) {
			throw new IllegalStateException("content.parts가 비어있습니다");
		}

		JsonNode textNode = partsNode.get(0).path("text");
		if (textNode.isMissingNode()) {
			throw new IllegalStateException("text 필드를 찾을 수 없습니다");
		}

		return textNode.asText();
	}

	@Override
	public String getGeminiResponse(String question) {

		if (apiKey == null || apiKey.isEmpty()) {
			throw new IllegalStateException("API 키가 설정되지 않았습니다.");
		}

		String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key="
				+ apiKey;
		question = question + "(책에 관해서만 답변, 책의 제목만 추천해주면 됨, 이모지나 특수문자는 표기하지 않음, 대답은 짧게 1문장으로 요약)";
//		question = question + "(책에 관해서만 답변, 이모지나 특수문자는 표기하지 않음, 대답은 가능한 짧게 1문장으로 요약)";
//        question = "(책이 아닌 질문에는 '책과 관련된 질문을 해주세요.'라고 답변, 이모지나 특수문자 표기X, 대답은 무조건 짧게 한 문장으로 요약)"+question;
		String requestBody = """
				{
				  "contents": [{
				    "parts": [{"text": "%s"}]
				  }]
				}
				""".formatted(question);

		HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(requestBody)).build();

		try {
			HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
			// 응답에서 실제 답변 텍스트만 추출
			return extractReplyText(response.body());
		} catch (Exception e) {
			throw new RuntimeException("API 호출 중 오류가 발생했습니다.", e);
		}
	}
}
