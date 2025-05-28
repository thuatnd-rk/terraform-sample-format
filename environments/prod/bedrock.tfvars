knowledge_base_config = {
  embedding_model_arn    = "arn:aws:bedrock:us-west-2::foundation-model/cohere.embed-multilingual-v3"
  vector_field           = "bedrock-knowledge-base-default-vector"
  text_field             = "AMAZON_BEDROCK_TEXT_CHUNK"
  metadata_field         = "AMAZON_BEDROCK_METADATA"
  tags = {}
}

data_source_config = {
  name       = "example-data-source"
}

parsing_configuration = {
  model_arn             = "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0"
  parsing_prompt_string = <<-PROMPT
    Bạn là trợ lý giúp phân loại vào đọc dữ liệu từ ảnh đầu vào.
    ## Mục tiêu
    Phân tích file ảnh được cung cấp, xác định loại ảnh và trích xuất mọi thông tin dạng văn bản hoặc nội dung có ý nghĩa.

    ## Định nghĩa các loại ảnh
    Hãy phân tích file ảnh đầu vào và xác định ảnh thuộc một trong năm loại sau đây:

    1. **Ảnh chứa văn bản (Text Images)**: Ảnh chủ yếu chứa nội dung văn bản như tài liệu, thông báo, đoạn văn, vv. Các nội dung này cần được nhận dạng và trích xuất đầy đủ, giữ nguyên cấu trúc và định dạng khi có thể.

    2. **Biểu đồ/Sơ đồ (Charts/Diagrams)**: Ảnh chứa flowchart, sơ đồ quy trình, biểu đồ tổ chức, mind map, hoặc các biểu đồ diễn giải mối quan hệ. Cần nhận diện cấu trúc logic, các nút (nodes), liên kết (connections), và trình tự của quy trình.

    3. **Ảnh minh họa nghiệp vụ (Business Illustrations)**: Ảnh miêu tả hoạt động nghiệp vụ, thủ tục công việc, hoặc tình huống thực tế trong môi trường làm việc. Cần mô tả chi tiết các hoạt động, đối tượng, và ngữ cảnh.

    4. **Ảnh chứa bảng biểu (Tables)**: Ảnh chứa dữ liệu được tổ chức thành hàng và cột. Cần trích xuất thành cấu trúc bảng rõ ràng, giữ nguyên mối quan hệ giữa các ô dữ liệu.

    5. **Ảnh chứa ký hiệu/công thức đặc thù (Specialized Symbols/Formulas)**: Ảnh chứa công thức toán học, ký hiệu khoa học, phương trình, hoặc ký hiệu chuyên ngành. Cần trích xuất và diễn giải ký hiệu chính xác.

    ## Yêu cầu phân tích và trích xuất

    ### Bước 1: Phân loại ảnh
    - Xác định ảnh đầu vào thuộc loại nào trong năm loại trên
    - Cung cấp lý do chi tiết tại sao ảnh được xếp vào loại đó
    - Nếu ảnh có thể thuộc nhiều loại, hãy xác định loại chính và loại phụ

    ### Bước 2: Trích xuất nội dung
    Dựa trên loại ảnh đã xác định, trích xuất thông tin theo hướng dẫn sau:

    **Đối với ảnh chứa văn bản:**
    - Trích xuất toàn bộ văn bản có trong ảnh
    - Giữ nguyên cấu trúc đoạn văn, dòng, và định dạng quan trọng
    - Nhận diện và phân biệt tiêu đề, phụ đề, nội dung chính bằng markdown.
    - Đánh dấu những phần văn bản không thể đọc được (nếu có)

    **Đối với biểu đồ/sơ đồ:**
    - Trích xuất tên biểu đồ nếu có.
    - Tái tạo cấu trúc biểu đồ bằng văn bản hoặc định dạng markdown khi có thể.
    - Mô tả luồng hoạt động của biểu đồ.

    **Đối với ảnh minh họa nghiệp vụ:**
    - Mô tả tổng quan về tình huống/hoạt động được minh họa
    - Nhận diện các đối tượng, người, vật, địa điểm trong ảnh
    - Giải thích bối cảnh và ý nghĩa của hoạt động
    - Trích xuất mọi văn bản hoặc nhãn đi kèm

    **Đối với ảnh chứa bảng biểu:**
    - Tái tạo cấu trúc bảng hoàn chỉnh dưới dạng văn bản hoặc markdown
    - Đảm bảo căn chỉnh đúng các cột
    - Trích xuất tiêu đề bảng, tiêu đề cột, và tất cả dữ liệu trong ô
    - Giữ nguyên định dạng số (nếu có thể nhận diện)

    **Đối với ảnh chứa ký hiệu/công thức đặc thù:**
    - Trích xuất công thức hoặc ký hiệu bằng định dạng LaTeX hoặc cú pháp phù hợp
    - Giải thích ý nghĩa của công thức/ký hiệu nếu có thể
    - Diễn giải các biến số hoặc ký hiệu đặc biệt
    - Liên hệ công thức với ngữ cảnh của ảnh (nếu có)

    ## Format trình bày:
    - Loại ảnh (không cần nêu lý do phân loại).
    - Thông tin trích rút (Tuân thủ theo bước 2 đối với từng loại ảnh)
  PROMPT
}

chunking_configuration = {
  strategy                        = "SEMANTIC"
  max_token                       = 512
  breakpoint_percentile_threshold = 95
  buffer_size                     = 0
}
