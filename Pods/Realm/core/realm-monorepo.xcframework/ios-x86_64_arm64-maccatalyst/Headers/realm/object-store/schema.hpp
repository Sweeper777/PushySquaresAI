////////////////////////////////////////////////////////////////////////////
//
// Copyright 2015 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_SCHEMA_HPP
#define REALM_SCHEMA_HPP

#include <string>
#include <unordered_set>
#include <vector>

#include <realm/util/features.h>

namespace realm {
class ObjectSchema;
class SchemaChange;
class StringData;
struct TableKey;
struct Property;

enum SchemaValidationMode : uint64_t { Basic = 0, Sync = 1, RejectEmbeddedOrphans = 2 };

class Schema : private std::vector<ObjectSchema> {
private:
    using base = std::vector<ObjectSchema>;

public:
    Schema() noexcept;
    ~Schema();
    // Create a schema from a vector of ObjectSchema
    Schema(base types) noexcept;
    Schema(std::initializer_list<ObjectSchema> types);

    Schema(Schema const&);
    Schema(Schema&&) noexcept;
    Schema& operator=(Schema const&);
    Schema& operator=(Schema&&) noexcept;

    // find an ObjectSchema by name
    iterator find(StringData name) noexcept;
    const_iterator find(StringData name) const noexcept;

    // find an ObjectSchema with the same name as the passed in one
    iterator find(ObjectSchema const& object) noexcept;
    const_iterator find(ObjectSchema const& object) const noexcept;

    // find an ObjectSchema by table key
    iterator find(TableKey table_key) noexcept;
    const_iterator find(TableKey table_key) const noexcept;

    // Verify that this schema is internally consistent (i.e. all properties are
    // valid, links link to types that actually exist, etc.)
    void validate(uint64_t validation_mode = SchemaValidationMode::Basic) const;
    std::unordered_set<std::string> get_embedded_object_orphans() const;

    // Get the changes which must be applied to this schema to produce the passed-in schema
    std::vector<SchemaChange> compare(Schema const&, bool include_removals = false) const;

    void copy_keys_from(Schema const&) noexcept;

    friend bool operator==(Schema const&, Schema const&) noexcept;
    friend bool operator!=(Schema const& a, Schema const& b) noexcept
    {
        return !(a == b);
    }

    using base::begin;
    using base::const_iterator;
    using base::empty;
    using base::end;
    using base::iterator;
    using base::size;

private:
    template <typename T, typename U, typename Func>
    static void zip_matching(T&& a, U&& b, Func&& func) noexcept;
};

namespace schema_change {
struct AddTable {
    const ObjectSchema* object;
};

struct RemoveTable {
    const ObjectSchema* object;
};

struct ChangeTableType {
    const ObjectSchema* object;
};

struct AddInitialProperties {
    const ObjectSchema* object;
};

struct AddProperty {
    const ObjectSchema* object;
    const Property* property;
};

struct RemoveProperty {
    const ObjectSchema* object;
    const Property* property;
};

struct ChangePropertyType {
    const ObjectSchema* object;
    const Property* old_property;
    const Property* new_property;
};

struct MakePropertyNullable {
    const ObjectSchema* object;
    const Property* property;
};

struct MakePropertyRequired {
    const ObjectSchema* object;
    const Property* property;
};

struct AddIndex {
    const ObjectSchema* object;
    const Property* property;
};

struct RemoveIndex {
    const ObjectSchema* object;
    const Property* property;
};

struct ChangePrimaryKey {
    const ObjectSchema* object;
    const Property* property;
};
} // namespace schema_change

#define REALM_FOR_EACH_SCHEMA_CHANGE_TYPE(macro)                                                                     \
    macro(AddTable) macro(RemoveTable) macro(ChangeTableType) macro(AddInitialProperties) macro(AddProperty)         \
        macro(RemoveProperty) macro(ChangePropertyType) macro(MakePropertyNullable) macro(MakePropertyRequired)      \
            macro(AddIndex) macro(RemoveIndex) macro(ChangePrimaryKey)

class SchemaChange {
public:
#define REALM_SCHEMA_CHANGE_CONSTRUCTOR(name)                                                                        \
    SchemaChange(schema_change::name value)                                                                          \
        : m_kind(Kind::name)                                                                                         \
    {                                                                                                                \
        name = value;                                                                                                \
    }
    REALM_FOR_EACH_SCHEMA_CHANGE_TYPE(REALM_SCHEMA_CHANGE_CONSTRUCTOR)
#undef REALM_SCHEMA_CHANGE_CONSTRUCTOR

    template <typename Visitor>
    auto visit(Visitor&& visitor) const
    {
        switch (m_kind) {
#define REALM_SWITCH_CASE(name)                                                                                      \
    case Kind::name:                                                                                                 \
        return visitor(name);
            REALM_FOR_EACH_SCHEMA_CHANGE_TYPE(REALM_SWITCH_CASE)
#undef REALM_SWITCH_CASE
        }
        REALM_COMPILER_HINT_UNREACHABLE();
    }

    friend bool operator==(SchemaChange const& lft, SchemaChange const& rgt) noexcept;

private:
    enum class Kind {
#define REALM_SCHEMA_CHANGE_TYPE(name) name,
        REALM_FOR_EACH_SCHEMA_CHANGE_TYPE(REALM_SCHEMA_CHANGE_TYPE)
#undef REALM_SCHEMA_CHANGE_TYPE

    } m_kind;
    union {
#define REALM_DEFINE_FIELD(name) schema_change::name name;
        REALM_FOR_EACH_SCHEMA_CHANGE_TYPE(REALM_DEFINE_FIELD)
#undef REALM_DEFINE_FIELD
    };
};

#undef REALM_FOR_EACH_SCHEMA_CHANGE_TYPE
} // namespace realm

#endif /* defined(REALM_SCHEMA_HPP) */
