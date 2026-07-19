-- ============================================
-- CHOSEN ONE — Script SQL para criar tabelas no Neon/PostgreSQL
-- ============================================
-- Cole este script no SQL Editor do Neon e clique em Run

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS "Product" (
    "id" TEXT PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "image" TEXT NOT NULL,
    "images" TEXT NOT NULL DEFAULT '',
    "sizes" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT 'Coleção',
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "inStock" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Tabela de admin
CREATE TABLE IF NOT EXISTS "Admin" (
    "id" TEXT PRIMARY KEY,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- Tabela de configurações
CREATE TABLE IF NOT EXISTS "SiteSetting" (
    "id" TEXT PRIMARY KEY,
    "key" TEXT NOT NULL UNIQUE,
    "value" TEXT NOT NULL
);

-- Tabela de logs de auditoria
CREATE TABLE IF NOT EXISTS "AuditLog" (
    "id" TEXT PRIMARY KEY,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "summary" TEXT NOT NULL,
    "details" TEXT NOT NULL DEFAULT '{}',
    "adminUser" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");
CREATE INDEX IF NOT EXISTS "AuditLog_entity_action_idx" ON "AuditLog"("entity", "action");

-- Tabela de cliques (analytics)
CREATE TABLE IF NOT EXISTS "ProductClick" (
    "id" TEXT PRIMARY KEY,
    "productId" TEXT,
    "productName" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "size" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS "ProductClick_createdAt_idx" ON "ProductClick"("createdAt");
CREATE INDEX IF NOT EXISTS "ProductClick_productId_type_idx" ON "ProductClick"("productId", "type");
CREATE INDEX IF NOT EXISTS "ProductClick_productName_idx" ON "ProductClick"("productName");

-- ============================================
-- Inserir admin padrão (admin / admin123)
-- A senha está hasheada com scrypt
-- ============================================
INSERT INTO "Admin" ("id", "username", "password", "createdAt", "updatedAt")
VALUES (
    'admin-default-001',
    'admin',
    'f9f6ca4184dd67373fec4e0d2f7e8b1f:19e0f5f9822713d12501c0bd14cbf01901d856d26ad8a6ab0e2547279709f146a02e08b432c1c7ffff0998fa9ef4c659d910580932fe2dd64fed940d1fb0b640',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT ("username") DO NOTHING;

-- ============================================
-- Inserir configurações padrão
-- ============================================
INSERT INTO "SiteSetting" ("id", "key", "value") VALUES
    ('set-01', 'storeName', 'CHOSEN ONE'),
    ('set-02', 'storeTagline', 'O escolhido não erra. Apenas decide.'),
    ('set-03', 'heroTitle', 'SEJA O\nESCOLHIDO.'),
    ('set-04', 'heroSubtitle', 'Streetwear para quem não pede licença. Cada peça é uma declaração. O resto é barulho.'),
    ('set-05', 'heroBadge', 'COLEÇÃO 01 — DESTINO'),
    ('set-06', 'whatsappNumber', '5511999999999'),
    ('set-07', 'whatsappMessage', 'Olá! Tenho interesse na peça {product} (Tam: {size}) — valor R$ {price}. Quero finalizar a compra.'),
    ('set-08', 'contactEmail', 'contato@chosenone.com.br'),
    ('set-09', 'contactInstagram', '@chosenone'),
    ('set-10', 'footerText', 'CHOSEN ONE — Nascidos para ser escolhidos, não para ser mais um.'),
    ('set-11', 'logoImage', '/uploads/co-logo-red.png'),
    ('set-12', 'marqueeText', 'CHOSEN ONE • O ESCOLHIDO NÃO ERRA • VOCÊ DECIDE QUANDO TERMINA • UM PASSO DE CADA VEZ • NÃO NASCEMOS PARA SER MAIS UM •')
ON CONFLICT ("key") DO NOTHING;

-- ============================================
-- Inserir produtos iniciais (15 peças)
-- ============================================
INSERT INTO "Product" ("id", "name", "description", "price", "image", "images", "sizes", "category", "featured", "inStock", "createdAt", "updatedAt") VALUES
    ('prod-01', 'Logo Oval — Branco', 'Camiseta branca com a logo CHOSEN ONE em badge oval azul metálico com estrelas. A peça identidade da marca.', 189.90, '/uploads/co-tee-01-logo-oval-branco.png', '', 'P,M,G,GG,XG', 'Identidade', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-02', 'Escolhido Não Erra', 'Camiseta branca com "ESCOLHIDO NÃO ERRA" em preto sobre ilustração editorial. Declaração de atitude.', 199.90, '/uploads/co-tee-02-escolhido-nao-erra.png', '', 'P,M,G,GG,XG', 'Manifesto', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-03', 'You Decide When It Ends — Branco', 'Camiseta branca com corrente de rosário na frente e "YOU DECIDE WHEN IT ENDS" nas costas.', 209.90, '/uploads/co-tee-03-you-decide-branco.png', '/uploads/co-tee-06-you-decide-preto.png', 'P,M,G,GG', 'Destino', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-04', 'Horsepower Engine', 'Camiseta branca com ilustração de motor com supercharger na frente e silhueta de carro esportivo nas costas.', 219.90, '/uploads/co-tee-04-horsepower-engine.png', '', 'P,M,G,GG', 'Round', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-05', 'You Chose What You Want — Preto', 'Camiseta preta com "YOU CHOSEN WHAT YOU WANT" em gradiente laranja-amarelo e slot machine nas costas.', 199.90, '/uploads/co-tee-05-you-chose-preto.png', '/uploads/co-tee-07-you-chose-branco.png', 'P,M,G,GG,XG', 'Destino', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-06', 'You Decide When It Ends — Preto', 'Camiseta preta com corrente de rosário prateada na frente e "YOU DECIDE WHEN IT ENDS" em branco nas costas.', 209.90, '/uploads/co-tee-06-you-decide-preto.png', '/uploads/co-tee-03-you-decide-branco.png', 'P,M,G,GG,XG', 'Destino', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-07', 'You Chose What You Want — Branco', 'Camiseta branca com "YOU CHOSEN WHAT YOU WANT" em gradiente azul e slot machine nas costas.', 199.90, '/uploads/co-tee-07-you-chose-branco.png', '/uploads/co-tee-05-you-chose-preto.png', 'P,M,G,GG', 'Destino', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-08', 'One Round At A Time', 'Camiseta preta com boxeador x-ray na frente e "ONE STEP / ONE PUNCH / ONE ROUND AT A TIME" nas costas.', 219.90, '/uploads/co-tee-08-one-round-at-a-time.png', '', 'P,M,G,GG', 'Round', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-09', 'Never Again', 'Camiseta off-white com "Never The Again" em cursiva, silhueta com "NEVER AGAIN" e logo nas costas.', 229.90, '/uploads/co-tee-09-never-again.png', '', 'P,M,G,GG', 'Editorial', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-10', 'Dog Tags', 'Camiseta branca com placas de identificação militar (dog tags) em azul metálico penduradas em correntes.', 209.90, '/uploads/co-tee-10-dog-tags.png', '', 'P,M,G,GG', 'Identidade', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-11', 'Chosen One — Characters', 'Camiseta branca com "Chosen One" em cursiva e fileira de personagens coloridos. A peça mais ousada.', 219.90, '/uploads/co-tee-11-characters.png', '', 'P,M,G,GG', 'Editorial', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-12', 'Chosen One — Cars', 'Camiseta branca com "Chosen One" em cursiva e 9 carros coloridos em grade 3x3.', 219.90, '/uploads/co-tee-12-cars.png', '', 'P,M,G,GG', 'Round', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-13', 'Chosen One — Muse', 'Camiseta branca com "Chosen One" repetido em caligrafia e silhueta feminina. Estética urbana sofisticada.', 229.90, '/uploads/co-tee-13-muse.png', '', 'P,M,G,GG', 'Editorial', true, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-14', 'Chosen One — Portrait', 'Camiseta branca com "Chosen One" em cursiva vertical e retrato de homem com óculos vermelhos e arma.', 239.90, '/uploads/co-tee-14-portrait.png', '', 'P,M,G,GG', 'Editorial', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('prod-15', 'Horse & Car', 'Camiseta branca com ilustração monocromática de carro clássico com estrela e cavalo em pose saltitante.', 209.90, '/uploads/co-tee-15-horse-and-car.png', '', 'P,M,G,GG', 'Round', false, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT ("id") DO NOTHING;

-- Pronto! O banco está populado com:
-- - 1 admin (admin / admin123)
-- - 12 configurações
-- - 15 produtos
