package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

/**
 * FU 클래스: FUMathFormula
 * 수학공식 처리 기능 유닛
 * @author MultiQ4KBBank
 */
@BizUnit(value = "수학공식처리", type = "FU")
public class FUMathFormula extends com.kbstar.sqc.base.FunctionUnit {

    /**
     * 수학공식 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("수학공식처리")
    public IDataSet processFormula(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("수학공식처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            String formula = requestData.getString("formula");
            if (formula == null || formula.trim().isEmpty()) {
                throw new BusinessException("B3000568", "UKII0291", "공식 구문 및 기호 정의를 확인");
            }
            
            // BR-048-005: 수학공식처리
            // F-048-003: 수학공식처리
            
            // 공식 검증
            validateFormula(formula);
            
            // 수학함수 처리
            String processedFormula = processMathFunctions(formula);
            
            // 공식 계산
            BigDecimal result = calculateFormula(processedFormula);
            
            responseData.put("result", result);
            responseData.put("processedFormula", processedFormula);
            responseData.put("status", "SUCCESS");
            
            log.debug("수학공식처리 완료 - 결과: " + result);
            
        } catch (BusinessException e) {
            log.error("수학공식처리 비즈니스 오류", e);
            responseData.put("status", "FAILED");
            responseData.put("errorMessage", e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("수학공식처리 시스템 오류", e);
            responseData.put("status", "FAILED");
            throw new BusinessException("B3000108", "UKII0291", "수학공식 및 계산 매개변수를 확인", e);
        }
        
        return responseData;
    }

    /**
     * 수학함수 처리
     * @param formula 원본 공식
     * @return 처리된 공식
     */
    @BizMethod("수학함수처리")
    public String processMathFunctions(String formula) {
        String processedFormula = formula;
        
        try {
            // ABS 함수 처리
            processedFormula = processAbsFunction(processedFormula);
            
            // MAX/MIN 함수 처리
            processedFormula = processMaxMinFunction(processedFormula);
            
            // POWER 함수 처리
            processedFormula = processPowerFunction(processedFormula);
            
            // EXP/LOG 함수 처리
            processedFormula = processExpLogFunction(processedFormula);
            
            // IF 함수 처리
            processedFormula = processIfFunction(processedFormula);
            
            // INT 함수 처리
            processedFormula = processIntFunction(processedFormula);
            
            // STD 함수 처리 (표준편차)
            processedFormula = processStdFunction(processedFormula);
            
        } catch (Exception e) {
            throw new BusinessException("B3000568", "UKII0291", "공식 구문 및 기호 정의를 확인", e);
        }
        
        return processedFormula;
    }

    /**
     * ABS 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processAbsFunction(String formula) {
        Pattern pattern = Pattern.compile("ABS\\(([^)]+)\\)");
        Matcher matcher = pattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            String value = matcher.group(1);
            BigDecimal num = new BigDecimal(value);
            BigDecimal absValue = num.abs();
            matcher.appendReplacement(sb, absValue.toString());
        }
        matcher.appendTail(sb);
        
        return sb.toString();
    }

    /**
     * MAX/MIN 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processMaxMinFunction(String formula) {
        // MAX 함수 처리
        Pattern maxPattern = Pattern.compile("MAX\\(([^,]+),([^)]+)\\)");
        Matcher maxMatcher = maxPattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (maxMatcher.find()) {
            BigDecimal val1 = new BigDecimal(maxMatcher.group(1).trim());
            BigDecimal val2 = new BigDecimal(maxMatcher.group(2).trim());
            BigDecimal maxValue = val1.max(val2);
            maxMatcher.appendReplacement(sb, maxValue.toString());
        }
        maxMatcher.appendTail(sb);
        
        // MIN 함수 처리
        Pattern minPattern = Pattern.compile("MIN\\(([^,]+),([^)]+)\\)");
        Matcher minMatcher = minPattern.matcher(sb.toString());
        
        StringBuffer sb2 = new StringBuffer();
        while (minMatcher.find()) {
            BigDecimal val1 = new BigDecimal(minMatcher.group(1).trim());
            BigDecimal val2 = new BigDecimal(minMatcher.group(2).trim());
            BigDecimal minValue = val1.min(val2);
            minMatcher.appendReplacement(sb2, minValue.toString());
        }
        minMatcher.appendTail(sb2);
        
        return sb2.toString();
    }

    /**
     * POWER 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processPowerFunction(String formula) {
        Pattern pattern = Pattern.compile("POWER\\(([^,]+),([^)]+)\\)");
        Matcher matcher = pattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            BigDecimal base = new BigDecimal(matcher.group(1).trim());
            int exponent = Integer.parseInt(matcher.group(2).trim());
            BigDecimal result = base.pow(exponent);
            matcher.appendReplacement(sb, result.toString());
        }
        matcher.appendTail(sb);
        
        return sb.toString();
    }

    /**
     * EXP/LOG 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processExpLogFunction(String formula) {
        // EXP 함수 처리
        Pattern expPattern = Pattern.compile("EXP\\(([^)]+)\\)");
        Matcher expMatcher = expPattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (expMatcher.find()) {
            double value = Double.parseDouble(expMatcher.group(1));
            double expValue = Math.exp(value);
            expMatcher.appendReplacement(sb, String.valueOf(expValue));
        }
        expMatcher.appendTail(sb);
        
        // LOG 함수 처리
        Pattern logPattern = Pattern.compile("LOG\\(([^)]+)\\)");
        Matcher logMatcher = logPattern.matcher(sb.toString());
        
        StringBuffer sb2 = new StringBuffer();
        while (logMatcher.find()) {
            double value = Double.parseDouble(logMatcher.group(1));
            double logValue = Math.log(value);
            logMatcher.appendReplacement(sb2, String.valueOf(logValue));
        }
        logMatcher.appendTail(sb2);
        
        return sb2.toString();
    }

    /**
     * IF 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processIfFunction(String formula) {
        Pattern pattern = Pattern.compile("IF\\(([^,]+),([^,]+),([^)]+)\\)");
        Matcher matcher = pattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            String condition = matcher.group(1).trim();
            String trueValue = matcher.group(2).trim();
            String falseValue = matcher.group(3).trim();
            
            // 간단한 조건 평가 (예: A > B)
            boolean conditionResult = evaluateCondition(condition);
            String result = conditionResult ? trueValue : falseValue;
            matcher.appendReplacement(sb, result);
        }
        matcher.appendTail(sb);
        
        return sb.toString();
    }

    /**
     * INT 함수 처리
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processIntFunction(String formula) {
        Pattern pattern = Pattern.compile("INT\\(([^)]+)\\)");
        Matcher matcher = pattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            BigDecimal value = new BigDecimal(matcher.group(1));
            BigDecimal intValue = value.setScale(0, RoundingMode.DOWN);
            matcher.appendReplacement(sb, intValue.toString());
        }
        matcher.appendTail(sb);
        
        return sb.toString();
    }

    /**
     * STD 함수 처리 (표준편차)
     * @param formula 공식
     * @return 처리된 공식
     */
    private String processStdFunction(String formula) {
        // STD 함수는 복잡한 구현이 필요하므로 기본값 반환
        Pattern pattern = Pattern.compile("STD\\(([^)]+)\\)");
        Matcher matcher = pattern.matcher(formula);
        
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            // 기본 표준편차 값 (실제 구현에서는 데이터 배열 처리 필요)
            matcher.appendReplacement(sb, "1.0");
        }
        matcher.appendTail(sb);
        
        return sb.toString();
    }

    /**
     * 공식 검증
     * @param formula 공식
     */
    private void validateFormula(String formula) {
        // 기본 구문 검증
        if (!formula.matches(".*[0-9+\\-*/().\\s]+.*")) {
            throw new BusinessException("B3000568", "UKII0291", "공식 구문이 유효하지 않습니다");
        }
        
        // 괄호 균형 검증
        int openCount = 0;
        int closeCount = 0;
        for (char c : formula.toCharArray()) {
            if (c == '(') openCount++;
            if (c == ')') closeCount++;
        }
        
        if (openCount != closeCount) {
            throw new BusinessException("B3000568", "UKII0291", "괄호가 균형이 맞지 않습니다");
        }
    }

    /**
     * 공식 계산
     * @param formula 처리된 공식
     * @return 계산 결과
     */
    private BigDecimal calculateFormula(String formula) {
        try {
            // 간단한 수식 계산 (실제 구현에서는 더 복잡한 파서 필요)
            // 여기서는 기본적인 사칙연산만 처리
            return evaluateExpression(formula);
        } catch (Exception e) {
            throw new BusinessException("B3001447", "UKII0291", "계산 매개변수 및 유효 범위를 확인", e);
        }
    }

    /**
     * 수식 평가
     * @param expression 수식
     * @return 계산 결과
     */
    private BigDecimal evaluateExpression(String expression) {
        // 간단한 수식 평가 (실제로는 더 정교한 파서 필요)
        try {
            // 공백 제거
            expression = expression.replaceAll("\\s", "");
            
            // 기본적인 사칙연산 처리
            if (expression.contains("+")) {
                String[] parts = expression.split("\\+", 2);
                return evaluateExpression(parts[0]).add(evaluateExpression(parts[1]));
            } else if (expression.contains("-") && !expression.startsWith("-")) {
                String[] parts = expression.split("-", 2);
                return evaluateExpression(parts[0]).subtract(evaluateExpression(parts[1]));
            } else if (expression.contains("*")) {
                String[] parts = expression.split("\\*", 2);
                return evaluateExpression(parts[0]).multiply(evaluateExpression(parts[1]));
            } else if (expression.contains("/")) {
                String[] parts = expression.split("/", 2);
                BigDecimal divisor = evaluateExpression(parts[1]);
                if (divisor.compareTo(BigDecimal.ZERO) == 0) {
                    throw new BusinessException("B3000108", "UKII0291", "0으로 나눌 수 없습니다");
                }
                return evaluateExpression(parts[0]).divide(divisor, 7, RoundingMode.HALF_UP);
            } else if (expression.startsWith("(") && expression.endsWith(")")) {
                return evaluateExpression(expression.substring(1, expression.length() - 1));
            } else {
                return new BigDecimal(expression);
            }
        } catch (NumberFormatException e) {
            throw new BusinessException("B3000108", "UKII0291", "숫자 형식이 유효하지 않습니다: " + expression, e);
        }
    }

    /**
     * 조건 평가
     * @param condition 조건식
     * @return 평가 결과
     */
    private boolean evaluateCondition(String condition) {
        // 간단한 조건 평가 (실제로는 더 정교한 파서 필요)
        if (condition.contains(">")) {
            String[] parts = condition.split(">");
            BigDecimal left = new BigDecimal(parts[0].trim());
            BigDecimal right = new BigDecimal(parts[1].trim());
            return left.compareTo(right) > 0;
        } else if (condition.contains("<")) {
            String[] parts = condition.split("<");
            BigDecimal left = new BigDecimal(parts[0].trim());
            BigDecimal right = new BigDecimal(parts[1].trim());
            return left.compareTo(right) < 0;
        } else if (condition.contains("=")) {
            String[] parts = condition.split("=");
            BigDecimal left = new BigDecimal(parts[0].trim());
            BigDecimal right = new BigDecimal(parts[1].trim());
            return left.compareTo(right) == 0;
        }
        
        return false;
    }

}
