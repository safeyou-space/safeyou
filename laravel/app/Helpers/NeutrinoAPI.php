<?php


namespace App\Helpers;
/**
 * A PHP client for Neutrino API, see: https://www.neutrinoapi.com
 * This class currently does not cover ALL of the APIs (but feel free to add more if you find this useful!)
 */
class NeutrinoAPI
{
    // set your actual user-id here
    private $apiUser = '208284379';

    // set your actual api-key here
    private $apiKey = 'v5LfwX10Rfd5DRiFaMCvhFd3RMduX0Sc32FcEEZlmntOdkMa';


    const API_BASE_URL = 'https://neutrinoapi.com/';
    const DEFAULT_REQUEST_TIMEOUT = 20; // default API request timeout in seconds


    /**
     * Get gelocation information about an IP address
     * See: http://www.neutrinoapi.com/api/ip-info/
     * @param string $ipAddress
     * @param boolean $reverseLookup
     * @return array
     */
    public function ipInfo($ipAddress, $reverseLookup = false)
    {
        $data = array();
        $data['ip'] = $ipAddress;
        if ($reverseLookup) $data['reverse-lookup'] = 'true';
        return $this->postRequest("ip-info", $data);
    }


    /**
     * Validate and clean an email address
     * See: http://www.neutrinoapi.com/api/email-validate/
     * @param string $emailAddress
     * @param boolean $fixTypos
     * @return array
     */
    public function emailValidate($emailAddress, $fixTypos = false)
    {
        $data = array();
        $data['email'] = $emailAddress;
        if ($fixTypos) $data['fix-typos'] = 'true';
        return $this->postRequest("email-validate", $data);
    }


    /**
     * Validate, format and get location information about a phone number
     * See: http://www.neutrinoapi.com/api/phone-validate/
     * @param string $phoneNumber
     * @param string $countryCode
     * @return array
     */
    public function phoneValidate($phoneNumber, $countryCode = '')
    {
        $data = array();
        $data['number'] = $phoneNumber;
        if (!empty($countryCode)) $data['country-code'] = $countryCode;
        return $this->postRequest("phone-validate", $data);
    }


    /**
     * Convert currency and most known measurement types
     * See: http://www.neutrinoapi.com/api/convert/
     * @param any $fromValue
     * @param string $fromType
     * @param string $toType
     * @return array
     */
    public function convert($fromValue, $fromType, $toType)
    {
        $data = array();
        $data['from-value'] = $fromValue;
        $data['from-type'] = $fromType;
        $data['to-type'] = $toType;
        return $this->postRequest("convert", $data);
    }


    /**
     * Get detailed user-agent and mobile device information from a user-agent string
     * See: http://www.neutrinoapi.com/api/user-agent-info/
     * @param string $userAgent
     * @return array
     */
    public function userAgentInfo($userAgent)
    {
        $data = array();
        $data['user-agent'] = $userAgent;
        return $this->postRequest("user-agent-info", $data);
    }


    /**
     * Clean and sanitize untrusted HTML
     * See: http://www.neutrinoapi.com/api/html-clean/
     * @param string $content
     * @param string $outputType
     * @return string
     */
    public function htmlClean($content, $outputType)
    {
        $data = array();
        $data['content'] = $content;
        $data['output-type'] = $outputType;
        return $this->postRequest("html-clean", $data, false);
    }



    /**
     * Extract HTML tag contents or attributes from HTML
     * See: http://www.neutrinoapi.com/api/html-extract-tags/
     * @param string $content
     * @param string $tag
     * @param string $attribute
     * @param string $baseURL
     * @return array
     */
    public function htmlExtract($content, $tag, $attribute = '', $baseURL = '')
    {
        $data = array();
        $data['content'] = $content;
        $data['tag'] = $tag;
        $data['attribute'] = $attribute;
        $data['base-url'] = $baseURL;
        return $this->postRequest("html-extract-tags", $data);
    }


    /**
     * Detect and censor bad words and swear words
     * See: http://www.neutrinoapi.com/api/bad-word-filter/
     * @param string $content
     * @param string $censorCharacter
     * @return array
     */
    public function badWordFilter($content, $censorCharacter = '*')
    {
        $data = array();
        $data['content'] = $content;
        $data['censor-character'] = $censorCharacter;
        return $this->postRequest("bad-word-filter", $data);
    }


    /**
     * Convert HTML to a PDF document
     * See: http://www.neutrinoapi.com/api/html-to-pdf/
     * @param string $content
     * @param string $filePath the file path to save the PDF to
     * @param number $htmlWidth
     * @param number $margin
     * @param string $title
     */
    public function htmlToPDF($content, $filePath, $htmlWidth = '', $margin = '', $title = '')
    {
        $data = array();
        $data['content'] = $content;
        $data['html-width'] = $htmlWidth;
        $data['margin'] = $margin;
        $data['title'] = $title;
        $this->postRequestToFile("html-to-pdf", $data, $filePath, 25);
    }


    /**
     * Generate a QR code image (PNG)
     * See: http://www.neutrinoapi.com/api/qr-code/
     * @param string $content
     * @param string $filePath the file path to save the PNG image to
     * @param number $width
     * @param number $height
     * @param string $fgColor
     * @param string $bgColor
     */
    public function qrCode($content, $filePath, $width = '', $height = '', $fgColor = '', $bgColor = '')
    {
        $data = array();
        $data['content'] = $content;
        $data['width'] = $width;
        $data['height'] = $height;
        $data['fg-color'] = $fgColor;
        $data['bg-color'] = $bgColor;
        $this->postRequestToFile("qr-code", $data, $filePath);
    }


    /**
     * Post to the API and return response as either associative array or as-is
     */
    private function postRequest($path, $data, $returnArray = true, $timeout = self::DEFAULT_REQUEST_TIMEOUT)
    {
        $data['user-id'] = $this->apiUser;
        $data['api-key'] = $this->apiKey;
        $ch = curl_init(self::API_BASE_URL.$path);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
        $content = curl_exec($ch);
        curl_close($ch);
        if ($returnArray) return json_decode($content, true);
        else return $content;
    }


    /**
     * Post to the API and save the response into a file
     */
    private function postRequestToFile($path, $data, $filePath, $timeout = self::DEFAULT_REQUEST_TIMEOUT)
    {
        $out = fopen($filePath, "wb");
        if ($out === FALSE) return false;
        $data['user-id'] = $this->apiUser;
        $data['api-key'] = $this->apiKey;
        $ch = curl_init(self::API_BASE_URL.$path);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_FILE, $out);
        curl_exec($ch);
        curl_close($ch);
        return true;
    }

}

?>
